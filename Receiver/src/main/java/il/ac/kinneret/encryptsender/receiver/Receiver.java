package il.ac.kinneret.encryptsender.receiver;

import il.ac.kinneret.encryptsender.receiver.util.Constants;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.security.GeneralSecurityException;

public class Receiver {

    private final String ip;
    private final int port;
    private final String suite;
    private final String tempfile;
    private final String outfile;
    private final byte[] key;
    private final byte[] iv;

    public Receiver(String ip, int port, String suite, String tempfile, String outfile, byte[] key, byte[] iv) {
        this.ip = ip;
        this.port = port;
        this.suite = suite;
        this.tempfile = tempfile;
        this.outfile = outfile;
        this.key = key;
        this.iv = iv;
    }

    public void receiveAndDecrypt() {
        try (ServerSocket serverSocket = new ServerSocket(port)) {
            Socket clientSocket = serverSocket.accept();

            // Step 1: Receive encrypted bytes and write to tempfile
            try (InputStream in = clientSocket.getInputStream();
                 FileOutputStream fileOut = new FileOutputStream(tempfile)) {

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    fileOut.write(buffer, 0, bytesRead);
                }

                System.out.printf(Constants.RECEIVED_ENCRYPTED_FILE, tempfile);
            } catch (IOException e) {
                System.err.printf(Constants.ERROR_WRITING_TO_ENCRYPTED_FILE, e.getMessage());
                return;
            }

            // Step 2: Decrypt tempfile into outfile
            try (FileInputStream encryptedIn = new FileInputStream(tempfile);
                 FileOutputStream decryptedOut = new FileOutputStream(outfile)) {

                String algorithm = suite.split("/")[0];
                Cipher cipher = Cipher.getInstance(suite);
                SecretKeySpec secretKey = new SecretKeySpec(key, algorithm);
                IvParameterSpec ivSpec = new IvParameterSpec(iv);
                cipher.init(Cipher.DECRYPT_MODE, secretKey, ivSpec);

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = encryptedIn.read(buffer)) != -1) {
                    byte[] decrypted = cipher.update(buffer, 0, bytesRead);
                    if (decrypted != null) {
                        decryptedOut.write(decrypted);
                    }
                }

                byte[] finalBytes = cipher.doFinal();
                if (finalBytes != null) {
                    decryptedOut.write(finalBytes);
                }

                System.out.printf(Constants.FINISHED_DECRYPTING_FILE, outfile);
            } catch (GeneralSecurityException | IOException e) {
                System.err.printf(Constants.ERROR_READING_OR_WRITING_THE_FILEs, e.getMessage());
            }

        } catch (IOException e) {
            System.err.printf(Constants.ERROR_PARSING_LISTENING_ADDRESS, e.getMessage());
        }
    }
}

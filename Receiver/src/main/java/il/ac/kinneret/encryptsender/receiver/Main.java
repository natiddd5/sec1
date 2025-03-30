package il.ac.kinneret.encryptsender.receiver;

import il.ac.kinneret.encryptsender.receiver.util.ByteManipulation;
import il.ac.kinneret.encryptsender.receiver.util.Constants;

public class Main {

    // Minimum required args (ip, port, suite, tempfile, outfile, key, iv)
//    private static final int MIN_REQUIRED_ARG_COUNT = 7;

    public static void main(String[] args) {
//        if (args.length < MIN_REQUIRED_ARG_COUNT) {
//            System.out.println(Constants.RECEIVER_USAGE);
//            System.exit(1);
//        }
        
        String ip = null;
        int port = -1;
        String suite = null;
        String tempfile = null;
        String outfile = null;
        String keyHex = null;
        String ivHex = null;
        int tagLength = 128; // default tag length for GCM mode

        for (String arg : args) {
            if (arg.startsWith("-ip=")) {
                ip = arg.substring("-ip=".length());
            } else if (arg.startsWith("-port=")) {
                port = Integer.parseInt(arg.substring("-port=".length()));
            } else if (arg.startsWith("-suite=")) {
                suite = arg.substring("-suite=".length());
            } else if (arg.startsWith("-tempfile=")) {
                tempfile = arg.substring("-tempfile=".length()).replaceAll("\"", "");
            } else if (arg.startsWith("-outfile=")) {
                outfile = arg.substring("-outfile=".length()).replaceAll("\"", "");
            } else if (arg.startsWith("-key=")) {
                keyHex = arg.substring("-key=".length());
            } else if (arg.startsWith("-iv=")) {
                ivHex = arg.substring("-iv=".length());
            } else if (arg.startsWith("-taglength=")) {
                tagLength = Integer.parseInt(arg.substring("-taglength=".length()));
            }
        }

        String alg = suite.split("/")[0];
        if (!alg.equals("AES")  && !alg.equals("DES")) {
            System.out.print(String.format(Constants.INVALID_ALGORITHM_CHOSEN, suite));
            System.out.print(Constants.RECEIVER_USAGE);
            System.exit(0);
        }

        if (ip == null || port < 0 || suite == null || tempfile == null || outfile == null
                || keyHex == null || ivHex == null) {
            System.out.print(Constants.RECEIVER_USAGE);
            System.exit(0);
        }

        byte[] key, iv;
        try {
            key = ByteManipulation.hexToBytes(keyHex);
            iv = ByteManipulation.hexToBytes(ivHex);
        } catch (Exception e) {
            System.err.printf(Constants.ERROR_CREATING_KEY_OR_IV, e.getMessage());
            return;
        }

        Receiver receiver = new Receiver(ip, port, suite, tempfile, outfile, key, iv, tagLength);
        receiver.receiveAndDecrypt();
    }
}

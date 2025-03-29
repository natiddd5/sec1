package il.ac.kinneret.encryptsender.receiver;

import il.ac.kinneret.encryptsender.receiver.util.ByteManipulation;
import il.ac.kinneret.encryptsender.receiver.util.Constants;

public class Main {

    private static final int REQUIRED_ARG_COUNT = 7;

    public static void main(String[] args) {
        if (args.length < REQUIRED_ARG_COUNT) {
            System.out.println(Constants.RECEIVER_USAGE);
            System.exit(1);
        }

        String ip = null;
        int port = -1;
        String suite = null;
        String tempfile = null;
        String outfile = null;
        String keyHex = null;
        String ivHex = null;

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
            }
        }

        if (ip == null || port < 0 || suite == null || tempfile == null || outfile == null
                || keyHex == null || ivHex == null) {
            System.out.println(Constants.RECEIVER_USAGE);
            System.exit(1);
        }

        System.out.printf("ip=%s port=%d suite=%s tempfile=%s outfile=%s key=%s iv=%s%n", ip, port, suite, tempfile, outfile, keyHex, ivHex);

        byte[] key, iv;
        try {
            key = ByteManipulation.hexToBytes(keyHex);
            iv = ByteManipulation.hexToBytes(ivHex);
        } catch (Exception e) {
            System.err.printf(Constants.ERROR_CREATING_KEY_OR_IV, e.getMessage());
            return;
        }

        Receiver receiver = new Receiver(ip, port, suite, tempfile, outfile, key, iv);
        receiver.receiveAndDecrypt();
    }
}
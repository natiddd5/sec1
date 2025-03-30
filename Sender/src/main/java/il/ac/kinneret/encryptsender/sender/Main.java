    package il.ac.kinneret.encryptsender.sender;

    import il.ac.kinneret.encryptsender.sender.util.ByteManipulation;
    import il.ac.kinneret.encryptsender.sender.util.Constants;

    import java.net.InetAddress;
    import java.net.UnknownHostException;

    //Nati Shen, Gadi Yohannan
    public class Main {


        private static int MAX_ARGS = 7;
        public static void main(String[] args) throws InterruptedException {
            if (args.length > MAX_ARGS) {
                showUsage("");
            }
            String dest = null;
            int port = -1;
            String suite = null;
            String infile = null;
            String keyHex = null;
            String ivHex = null;
            int tagLength = 128;

            for (String arg : args) {
                if (arg.startsWith("-dest=")) {
                    dest = arg.substring("-dest=".length());
                } else if (arg.startsWith("-port=")) {
                    port = Integer.parseInt(arg.substring("-port=".length()));
                } else if (arg.startsWith("-suite=")) {
                    suite = arg.substring("-suite=".length());
                } else if (arg.startsWith("-infile=")) {
                    infile = arg.substring("-infile=".length()).replaceAll("\"", "");
                } else if (arg.startsWith("-key=")) {
                    keyHex = arg.substring("-key=".length());
                } else if (arg.startsWith("-iv=")) {
                    ivHex = arg.substring("-iv=".length());
                }else if (arg.startsWith("-taglength=")) {
                    tagLength = Integer.parseInt(arg.substring("-taglength=".length()));
                }
            }
            if (dest == null || port < 0 || suite == null || infile == null
                    || keyHex == null || ivHex == null) {
                showUsage("");
            }

            try {
                InetAddress address = InetAddress.getByName(dest);
            } catch (UnknownHostException e) {
                String error = String.format(Constants.ERROR_PARSING_DESTINATION_ADDRESS, dest+": Name or service not known");
                showUsage(error);
            }


            byte[] key = ByteManipulation.hexToBytes(keyHex);
            byte[] iv = ByteManipulation.hexToBytes(ivHex);

            String alg = suite.split("/")[0];
            if (!alg.equals("AES")  && !alg.equals("DES")) {
                String error = String.format(Constants.INVALID_ALGORITHM_CHOSEN, suite);
                showUsage(error);
            }

            Sender sender = new Sender(dest, port, suite, infile, key, iv,tagLength);
            sender.sendMessage();
        }

        public static void showUsage(String errorMsg) {
            System.out.print(errorMsg+Constants.SENDER_USAGE);
            System.exit(0);
        }

    }
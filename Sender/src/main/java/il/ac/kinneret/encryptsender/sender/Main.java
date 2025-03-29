    package il.ac.kinneret.encryptsender.sender;

    import il.ac.kinneret.encryptsender.sender.util.ByteManipulation;
    import il.ac.kinneret.encryptsender.sender.util.Constants;

    //Nati Shen, Gadi Yohannan
    public class Main {


        private static int MAX_ARGS = 7;
        public static void main(String[] args) {
            if (args.length > MAX_ARGS) {
                showUsage();
            }
            String dest = null;
            int port = -1;
            String suite = null;
            String infile = null;
            String keyHex = null;
            String ivHex = null;

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
                }
            }

//            System.out.printf("dest=%s port=%d suite=%s infile=%s key=%s iv=%s%n", dest, port, suite, infile, keyHex, ivHex);

            if (dest == null || port < 0 || suite == null || infile == null
                    || keyHex == null || ivHex == null) {
                showUsage();
            }

            byte[] key = ByteManipulation.hexToBytes(keyHex);
            byte[] iv = ByteManipulation.hexToBytes(ivHex);

            Sender sender = new Sender(dest, port, suite, infile, key, iv);
            sender.sendMessage();

        }

        private static void showUsage() {;
            System.out.print(Constants.SENDER_USAGE);
            System.exit(0);
        }
    }
package il.ac.kinneret.encryptsender.sender.util;

/**
 * Class that contains constants and strings useful in the encrypted file sender tool
 *
 * @author Michael J. May
 * @version 1.0
 */
public class Constants {
    final public static String encrypt = "encrypt";
    final public static String decrypt = "decrypt";
    final public static String cbc = "cbc";
    final public static String ctr = "ctr";
    final public static String gcm = "gcm";
    final public static String aes = "aes";
    final public static String des = "des";
    final public static String noPadding = "NoPadding";
    final public static String PKCS5Padding = "PKCS5Padding";
    final public static String DEST = "dest";
    final public static String PORT = "port";

    public static final String KEY = "key";
    public static final String SUITE = "suite";
    public static final String OUTFILE = "outfile";
    public static final String INFILE = "infile";
    public static final String OPERATION = "operation";
    public static final String IV = "iv";
    public static final String SENDER_USAGE = "Usage: -infile=path/to/file -iv=iv -key=key -suite=cipher/mode/padding -dest=ip -port=p\n" +
            "iv and key in hexadecimal\n" +
            "suite must be a valid cipher suite (e.g. AES/CBC/NoPadding)\n" +
            "dest must be a valid IP address";
    public static final String SENT_FILE = "Sent file %s%n";
    public static final String ERROR_SENDING_FILE = "Error sending file: %s%n";
    public static final String ERROR_READING_OR_WRITING_THE_FILES = "Error reading or writing the files: %s%n";
    public static final String ERROR_CREATING_KEY_OR_IV = "Error creating key or IV: %s%n";
    public static final String INVALID_ALGORITHM_CHOSEN = "Invalid algorithm chosen: %s%n";
    public static final String INVALID_PADDING_ALGORITHM = "Invalid padding algorithm: %s%n";
    public static final String CANT_FIND_FILE = "Can't find file: %s%n";
    public static final String ERROR_PARSING_DESTINATION_ADDRESS = "Error parsing destination address: %s%n";
    public static final String ERROR_CREATING_TEMPORARY_FILE = "Error creating temporary file: %s%n";
    public static final String ILLEGAL_PORT = "Illegal port: %s%n";

}

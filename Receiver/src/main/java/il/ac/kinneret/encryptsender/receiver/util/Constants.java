package il.ac.kinneret.encryptsender.receiver.util;

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

    final public static String LISTENING_IP = "ip";
    final public static String PORT = "port";

    public static final String KEY = "key";
    public static final String SUITE = "suite";
    public static final String OUTFILE = "outfile";
    public static final String IV = "iv";
    public static final String TEMP_FILE = "tempfile";
    public static final String RECEIVER_USAGE = "Usage: -ip=ip -port=p -tempfile=path/to/file -outfile=path/to/file -iv=iv -key=key -suite=cipher/mode/padding\n" +
            "iv and key in hexadecimal\nsuite must be a valid cipher suite (e.g. AES/CBC/NoPadding)\nip must be a valid listening ip\n" +
            "tempfile is where to write received encrypted contents\n" +
            "outfile is where to write decrypted contents";
    public static final String FINISHED_DECRYPTING_FILE = "Finished decrypting file: %s%n";
    public static final String ERROR_READING_OR_WRITING_THE_FILEs = "Error reading or writing the files: %s%n";
    public static final String ERROR_CREATING_KEY_OR_IV = "Error creating key or IV: %s%n";
    public static final String INVALID_ALGORITHM_CHOSEN = "Invalid algorithm chosen: %s%n";
    public static final String INVALID_PADDING_ALGORITHM = "Invalid padding algorithm: %s%n";
    public static final String ERROR_RECEIVING_FILE = "Error receiving file: %s%n";
    public static final String ERROR_WRITING_TO_ENCRYPTED_FILE = "Error writing to encrypted file: %s%n";
    public static final String RECEIVED_ENCRYPTED_FILE = "Received encrypted file: %s%n";
    public static final String ERROR_PARSING_LISTENING_ADDRESS = "Error parsing listening address: %s%n";
    public static final String ILLEGAL_PORT = "Illegal port: %s%n";
    public static final String ERROR_INVALID_KEY_WHEN_DECRYPTING = "Error: Invalid key when decrypting: Invalid AES key length: %d bytes%n";
    public static final String ERROR_INVALID_IV_WHEN_DECRYPTING_INVALID_DES_IV = "Error: Invalid IV when decrypting: Invalid DES IV length: %d bytes%n";
    public static final String ERROR_INVALID_IV_WHEN_DECRYPTING_INVALID_AES_IV = "Error: Invalid IV when decrypting: Invalid AES IV length: %d bytes%n";
}

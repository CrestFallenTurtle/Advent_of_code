public class tools {
    
    // Always returns a positive value
    public static long calculate_mod(long value, long mod){
        return ((value % mod + mod) % mod);
    }
}

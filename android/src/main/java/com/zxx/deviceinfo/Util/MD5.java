package com.zxx.deviceinfo.Util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * MD5锷犲瘑绠楁硶
 * 
 * @author jijian
 * 
 */

public class MD5 {

	private static final char HEX_DIGITS[] = { '0', '1', '2', '3', '4', '5',
			'6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

	public static String md5(String s) {
		try {
			MessageDigest digest = java.security.MessageDigest
					.getInstance("MD5");
			digest.update(s.getBytes());
			byte messageDigest[] = digest.digest();

			return toHexString(messageDigest);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}

		return "";
	}

	private static String toHexString(byte[] b) { // String to byte
		StringBuilder sb = new StringBuilder(b.length * 2);
		for (int i = 0; i < b.length; i++) {
			sb.append(HEX_DIGITS[(b[i] & 0xf0) >>> 4]);
			sb.append(HEX_DIGITS[b[i] & 0x0f]);
		}
		return sb.toString();
	}

	/**
	 * MD5鏅?锷犲瘑
	 * 
	 * @param rawPass
	 *            鏄庢枃
	 * @return
	 */
	public final static String encode(String rawPass) {
		return encode(rawPass, null);
	}

	/**
	 * * MD5鐩愬?锷犲瘑
	 * 
	 * @param rawPass
	 *            鏄庢枃
	 * @param salt
	 *            鐩愬?
	 * @return
	 */
	public final static String encode(String rawPass, Object salt) {
		String saltedPass = mergePasswordAndSalt(rawPass, salt);
		try {
			MessageDigest messageDigest = MessageDigest.getInstance("MD5");
			byte[] digest = messageDigest.digest(saltedPass.getBytes("UTF-8"));
			return new String(encode(digest));
		} catch (Exception e) {
			return rawPass;
		}
	}

	/**
	 * 
	 * 鎷兼帴瀵嗙爜涓庣洂鍊?	 * 
	 * @param password
	 * @param salt
	 * @param strict
	 * 
	 * @return 瀵嗙爜{鐩愬?}
	 */
	private static String mergePasswordAndSalt(String password, Object salt) {
		if (salt == null || "".equals(salt.toString().trim())) {
			return password;
		}
		return password + "{" + salt.toString() + "}";
	}

	/**
	 * encode
	 * 
	 * @param bytes
	 * @return
	 */
	private static char[] encode(byte[] bytes) {
		char[] HEX = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a',
				'b', 'c', 'd', 'e', 'f' };
		int nBytes = bytes.length;
		char[] result = new char[2 * nBytes];
		int j = 0;
		for (int i = 0; i < nBytes; i++) {
			// Char for top 4 bits
			result[j++] = HEX[(0xF0 & bytes[i]) >>> 4];

			// Bottom 4
			result[j++] = HEX[(0x0F & bytes[i])];
		}
		return result;
	}

}
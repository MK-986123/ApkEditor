package com.gmail.heagoo.common;

import java.security.SecureRandom;

public class RandomUtil {

    private static final char[] letters = new char[]{'a', 'b', 'c', 'd', 'e',
            'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
            's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
    private static volatile SecureRandom r;

    public static String getRandomString(int bits) {
        if (r == null) {
            synchronized (RandomUtil.class) {
                if (r == null) {
                    r = new SecureRandom();
                }
            }
        }

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < bits; i++) {
            int index = r.nextInt(letters.length);
            sb.append(letters[index]);
        }
        return sb.toString();
    }
}

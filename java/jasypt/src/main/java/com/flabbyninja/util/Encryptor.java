package com.flabbyninja.util;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.jasypt.encryption.pbe.PooledPBEStringEncryptor;
import org.jasypt.encryption.pbe.config.SimpleStringPBEConfig;

import java.security.Security;

public class Encryptor {

    private static PooledPBEStringEncryptor initialiseEncryptor(String passphrase) {
        PooledPBEStringEncryptor encryptor = new PooledPBEStringEncryptor();
        SimpleStringPBEConfig config = new SimpleStringPBEConfig();
        config.setPassword(passphrase);
        config.setAlgorithm("PBEWithMD5AndDES");
        config.setKeyObtentionIterations("1000");
        config.setPoolSize("1");
        config.setProviderName("BC");
        config.setSaltGeneratorClassName("org.jasypt.salt.RandomSaltGenerator");
        config.setStringOutputType("base64");
        encryptor.setConfig(config);
        return encryptor;
    }

    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: java -jar <jarname> <data to be encrypted> <passphrase>");
            System.exit(-1);
        }

        String data_in_clear = args[0];
        String passphrase = args[1];

        Security.addProvider(new BouncyCastleProvider());
        PooledPBEStringEncryptor encryptor = initialiseEncryptor(passphrase);
        String encryptedValue = encryptor.encrypt(data_in_clear);
        System.out.println(encryptedValue);
    }
}

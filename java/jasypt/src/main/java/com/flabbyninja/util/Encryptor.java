package com.flabbyninja.util;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.jasypt.encryption.pbe.PooledPBEStringEncryptor;
import org.jasypt.encryption.pbe.config.SimpleStringPBEConfig;
import org.jasypt.iv.RandomIvGenerator;

import java.security.Security;

public class Encryptor {

    private final static String USAGE = "Usage: java -jar <jarname> <encrypt | decrypt> <data> <passphrase>";

    enum Operation {
        ENCRYPT,
        DECRYPT
    }

    private static PooledPBEStringEncryptor initialiseEncryptor(String passphrase) {
        Security.addProvider(new BouncyCastleProvider());
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
        encryptor.setIvGenerator(new RandomIvGenerator());
        return encryptor;
    }

    public static void main(String[] args) {
        if (args.length != 3) {
            System.out.println(USAGE);
            System.exit(-1);
        }

        String operation = args[0];
        String data_in_clear = args[1];
        String passphrase = args[2];

        PooledPBEStringEncryptor encryptor = initialiseEncryptor(passphrase);

        if (operation.equalsIgnoreCase(Operation.ENCRYPT.toString())) {
            completeOperation(passphrase, Operation.ENCRYPT, encryptor.encrypt(data_in_clear));
        } else if (operation.equalsIgnoreCase(Operation.DECRYPT.toString())) {
            completeOperation(passphrase, Operation.DECRYPT, encryptor.decrypt(data_in_clear));
        } else {
            System.out.println(USAGE);
            System.out.println("Error: Invalid operation chosen (" + operation + ")");
            System.exit(-1);
        }
    }

    private static void completeOperation(String passphrase, Operation operation, String processedData) {
        System.out.println("Mode: " + operation.toString());
        System.out.println(processedData);
    }
}

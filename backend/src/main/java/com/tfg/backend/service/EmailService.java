package com.tfg.backend.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void sendPremiumUpgradeEmail(String toEmail, String username) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("Tu cuenta ahora es premium");
        message.setText("Hola " + username + ",\n\n" +
                "Tu suscripción ha sido actualizada correctamente a PREMIUM.\n" +
                "Ya puedes acceder al contenido de aprendizaje de la aplicación.\n\n" +
                "¡Gracias por usar nuestra app!\n"
        );

        mailSender.send(message);
    }

    public void sendPremiumExpirationEmail(String toEmail, String username) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("Tu suscripción premium ha expirado");
        message.setText("Hola " + username + ",\n\n" +
                "Tu suscripción PREMIUM ha finalizado. Para seguir disfrutando de los beneficios, por favor renueva tu suscripción.\n\n" +
                "¡Gracias por usar nuestra app!\n"
        );

        mailSender.send(message);
    }
}

package com.tfg.backend.service;

import com.tfg.backend.domain.EMedal;
import com.tfg.backend.domain.User;
import com.tfg.backend.domain.UserMedal;
import com.tfg.backend.persistance.UserMedalRepository;
import org.springframework.stereotype.Service;

@Service
public class UserMedalService {

    public final UserMedalRepository userMedalRepository;

    public UserMedalService(UserMedalRepository userMedalRepository) {
        this.userMedalRepository = userMedalRepository;
    }

    public void saveMedalIfNotExists(User user, EMedal medal) {
        boolean medalExists = userMedalRepository.existsByUserAndMedal(user, medal);

        if(medalExists) return;

        UserMedal userMedal = new UserMedal();
        userMedal.setUser(user);
        userMedal.setMedal(medal);

        userMedalRepository.save(userMedal);
    }

    public void checkStreakMedals(User user) {
        if (user.getStreak() >= 1) {
            saveMedalIfNotExists(user, EMedal.FIRST_LOGIN);
        } else if (user.getStreak() >= 5) {
            saveMedalIfNotExists(user, EMedal.STREAK_5);
        } else if (user.getStreak() >= 10) {
            saveMedalIfNotExists(user, EMedal.STREAK_10);
        } else if (user.getStreak() >= 25) {
            saveMedalIfNotExists(user, EMedal.STREAK_25);
        }
    }

    public void checkPremiumMedal(User user) {
        saveMedalIfNotExists(user, EMedal.PREMIUM_USER);
    }

    public void checkDanceExpertMedal(User user) {
        saveMedalIfNotExists(user, EMedal.DANCE_EXPERT);
    }
}

package com.tfg.backend.service;

import com.tfg.backend.domain.EMedal;
import com.tfg.backend.domain.User;
import com.tfg.backend.domain.UserMedal;
import com.tfg.backend.persistance.UserMedalRepository;
import com.tfg.backend.service.dto.UserDTO;
import com.tfg.backend.service.dto.UserMedalDTO;
import org.springframework.stereotype.Service;

import java.util.List;

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
        if (user.getStreak() >= 1) saveMedalIfNotExists(user, EMedal.FIRST_LOGIN);
        if (user.getStreak() >= 5) saveMedalIfNotExists(user, EMedal.STREAK_5);
        if (user.getStreak() >= 10) saveMedalIfNotExists(user, EMedal.STREAK_10);
        if (user.getStreak() >= 25) saveMedalIfNotExists(user, EMedal.STREAK_25);
    }

    public void checkPremiumMedal(User user) {
        saveMedalIfNotExists(user, EMedal.PREMIUM_USER);
    }

    public List<UserMedalDTO> getMedalsByUser(UserDTO user) {
        return userMedalRepository.findByUserId(user.getId())
                .stream()
                .map(this::toDTO)
                .toList();
    }

    private UserMedalDTO toDTO(UserMedal userMedal) {
        return new UserMedalDTO(
                userMedal.getId(),
                userMedal.getMedal().name()
        );
    }
}

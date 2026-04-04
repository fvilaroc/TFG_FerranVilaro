package com.tfg.backend.service;

import com.tfg.backend.domain.Difficulty;
import com.tfg.backend.domain.UserDanceProgress;
import com.tfg.backend.persistance.UserDanceProgressRepository;
import com.tfg.backend.service.dto.UserDanceProgressDTO;
import org.springframework.stereotype.Service;

@Service
public class UserDanceProgressService {

    private final UserDanceProgressRepository userDanceProgressRepository;

    public UserDanceProgressService(UserDanceProgressRepository userDanceProgressRepository) {
        this.userDanceProgressRepository = userDanceProgressRepository;
    }

    public Difficulty getDifficulty(Long userId, Long danceId) {
        UserDanceProgress progress = userDanceProgressRepository.findByUserIdAndDanceId(userId, danceId)
                .orElseThrow(() -> new RuntimeException("User dance progress not found for userId: " + userId + " and danceId: " + danceId));

        int points = progress.getPoints();

        if (points <= 100) {
            return Difficulty.EASY;
        } else if (points <= 300) {
            return Difficulty.MEDIUM;
        } else {
            return Difficulty.HARD;
        }
    }
}

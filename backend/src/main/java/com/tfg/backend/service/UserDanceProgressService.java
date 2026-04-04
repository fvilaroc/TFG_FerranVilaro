package com.tfg.backend.service;

import com.tfg.backend.domain.Dance;
import com.tfg.backend.domain.Difficulty;
import com.tfg.backend.domain.User;
import com.tfg.backend.domain.UserDanceProgress;
import com.tfg.backend.persistance.DanceRepository;
import com.tfg.backend.persistance.UserDanceProgressRepository;
import com.tfg.backend.persistance.UserRepository;
import com.tfg.backend.service.dto.UserDanceProgressDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserDanceProgressService {

    private final UserDanceProgressRepository userDanceProgressRepository;
    private final UserRepository userRepository;
    private final DanceRepository danceRepository;

    public UserDanceProgressService(UserDanceProgressRepository userDanceProgressRepository, UserRepository userRepository, DanceRepository danceRepository) {
        this.userDanceProgressRepository = userDanceProgressRepository;
        this.userRepository = userRepository;
        this.danceRepository = danceRepository;
    }

    public Difficulty getDifficulty(Long userId, Long danceId) {
        UserDanceProgress progress = userDanceProgressRepository.findByUserIdAndDanceId(userId, danceId)
                .orElseGet(() -> createNewProgress(userId, danceId));

        int points = progress.getPoints();

        if (points <= 100) {
            return Difficulty.EASY;
        } else if (points <= 300) {
            return Difficulty.MEDIUM;
        } else {
            return Difficulty.HARD;
        }
    }

    public UserDanceProgressDTO getUserDanceProgress(Long userId, Long danceId) {
        UserDanceProgress progress = userDanceProgressRepository.findByUserIdAndDanceId(userId, danceId)
                .orElseThrow(() -> new RuntimeException("Progress not found for userId: " + userId + " and danceId: " + danceId));

        return toDTO(progress);
    }

    public List<UserDanceProgressDTO> getAllProgressByUser (Long userId) {
        List<UserDanceProgress> progressList = userDanceProgressRepository.findAllByUserId(userId);
        return progressList.stream().map(this::toDTO).toList();
    }

    public void addPointsToUserDance(Long userId, Long danceId, int pointsToAdd) {
        UserDanceProgress progress = userDanceProgressRepository.findByUserIdAndDanceId(userId, danceId)
                .orElseGet(() -> createNewProgress(userId, danceId));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));

        user.setPoints(user.getPoints() + pointsToAdd);
        progress.setPoints(progress.getPoints() + pointsToAdd);

        userRepository.save(user);
        userDanceProgressRepository.save(progress);
    }

    private UserDanceProgressDTO toDTO(UserDanceProgress progress) {
        return new UserDanceProgressDTO(
                progress.getId(),
                progress.getUser().getId(),
                progress.getDance().getId(),
                progress.getPoints(),
                progress.getLevel()
        );
    }

    private UserDanceProgress createNewProgress(Long userId, Long danceId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));

        Dance dance = danceRepository.findById(danceId)
                .orElseThrow(() -> new RuntimeException("Dance not found with id: " + danceId));

        UserDanceProgress progress = new UserDanceProgress();
        progress.setUser(user);
        progress.setDance(dance);
        progress.setPoints(0);

        return userDanceProgressRepository.save(progress);
    }
}

package com.tfg.backend.service;

import com.tfg.backend.domain.User;
import com.tfg.backend.domain.UserDanceProgress;
import com.tfg.backend.persistance.UserDanceProgressRepository;
import com.tfg.backend.persistance.UserRepository;
import com.tfg.backend.service.dto.DanceRankingDTO;
import com.tfg.backend.service.dto.GlobalRankingDTO;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RankingService {

    private final UserRepository userRepository;
    private final UserDanceProgressRepository userDanceProgressRepository;

    public RankingService(UserRepository userRepository, UserDanceProgressRepository userDanceProgressRepository) {
        this.userRepository = userRepository;
        this.userDanceProgressRepository = userDanceProgressRepository;
    }

    public List<GlobalRankingDTO> getGlobalRanking() {
        List<User> users = userRepository.findAllByOrderByPointsDesc();

        List<GlobalRankingDTO> ranking = new ArrayList<>();

        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);

            ranking.add(new GlobalRankingDTO(
                    i + 1,
                    user.getId(),
                    user.getUsername(),
                    user.getPoints()
            ));
        }

        return ranking;
    }

    public List<DanceRankingDTO> getDanceRanking(Long danceId) {
        List<UserDanceProgress> progresses = userDanceProgressRepository.findByDanceIdOrderByPointsDesc(danceId);

        List<DanceRankingDTO> ranking = new ArrayList<>();

        for (int i = 0; i < progresses.size(); i++) {
            UserDanceProgress progress = progresses.get(i);

            ranking.add(new DanceRankingDTO(
                    i + 1,
                    progress.getUser().getId(),
                    progress.getUser().getUsername(),
                    progress.getDance().getId(),
                    progress.getPoints(),
                    progress.getLevel()
            ));
        }

        return ranking;
    }
}

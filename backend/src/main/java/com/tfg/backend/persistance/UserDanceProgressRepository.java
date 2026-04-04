package com.tfg.backend.persistance;

import com.tfg.backend.domain.UserDanceProgress;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserDanceProgressRepository extends JpaRepository<UserDanceProgress, Long> {

    Optional<UserDanceProgress> findByUserIdAndDanceId(Long userId, Long danceId);

    List<UserDanceProgress> findAllByUserId(Long userId);

    List<UserDanceProgress> findByDanceIdOrderByPointsDesc(Long danceId);
}

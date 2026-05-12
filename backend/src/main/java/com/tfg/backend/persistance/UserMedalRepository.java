package com.tfg.backend.persistance;

import com.tfg.backend.domain.*;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserMedalRepository extends JpaRepository<UserMedal, Long> {

    boolean existsByUserAndMedal(User user, EMedal medal);

    List<UserMedal> findByUserId(Long userId);
}

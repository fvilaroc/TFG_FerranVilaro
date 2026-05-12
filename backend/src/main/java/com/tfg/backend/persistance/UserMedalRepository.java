package com.tfg.backend.persistance;

import com.tfg.backend.domain.EMedal;
import com.tfg.backend.domain.User;
import com.tfg.backend.domain.UserMedal;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserMedalRepository extends JpaRepository<UserMedal, Long> {

    boolean existsByUserAndMedal(User user, EMedal medal);
}

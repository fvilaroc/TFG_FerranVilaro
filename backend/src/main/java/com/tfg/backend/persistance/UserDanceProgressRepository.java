package com.tfg.backend.persistance;

import com.tfg.backend.domain.UserDanceProgress;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserDanceProgressRepository extends JpaRepository<UserDanceProgress, Long> {
}

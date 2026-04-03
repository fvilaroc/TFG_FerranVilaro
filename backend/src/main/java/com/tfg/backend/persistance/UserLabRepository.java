package com.tfg.backend.persistance;

import com.tfg.backend.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserLabRepository extends JpaRepository<User, Long> {
     Optional<User> findByUsername(String Username);
}

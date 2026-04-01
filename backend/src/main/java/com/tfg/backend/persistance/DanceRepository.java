package com.tfg.backend.persistance;

import com.tfg.backend.domain.Dance;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DanceRepository extends JpaRepository<Dance, Long> {
}

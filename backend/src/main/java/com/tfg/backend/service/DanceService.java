package com.tfg.backend.service;

import com.tfg.backend.domain.Dance;
import com.tfg.backend.persistance.DanceRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DanceService {

    private final DanceRepository danceRepository;

    public DanceService(DanceRepository danceRepository) {
        this.danceRepository = danceRepository;
    }

    public List<Dance> findAll() {
        return danceRepository.findAll();
    }

    public Dance save(Dance dance) {
        return danceRepository.save(dance);
    }

    public void deleteById(Long id) {
        danceRepository.deleteById(id);
    }

    public void deleteAll() {
        danceRepository.deleteAll();
    }
}

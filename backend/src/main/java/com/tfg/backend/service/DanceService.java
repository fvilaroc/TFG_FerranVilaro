package com.tfg.backend.service;

import com.tfg.backend.domain.Dance;
import com.tfg.backend.persistance.DanceRepository;
import com.tfg.backend.service.dto.DanceDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DanceService {

    private final DanceRepository danceRepository;

    public DanceService(DanceRepository danceRepository) {
        this.danceRepository = danceRepository;
    }

    public List<DanceDTO> getAllDances() {

        List<Dance> dances = danceRepository.findAll();

        return dances.stream().map(this::toDTO).toList();
    }

    public DanceDTO getDanceById(Long id) {
        Dance dance = danceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Dance not found with id: " + id));
        return toDTO(dance);
    }

    public void saveDance(Dance dance) {
        danceRepository.save(dance);
    }

    public void deleteDanceById(Long id) {
        if (!danceRepository.existsById(id)) {
            throw new RuntimeException("Dance not found with id: " + id);
        }
        danceRepository.deleteById(id);
    }

    private DanceDTO toDTO(Dance dance) {
        return new DanceDTO(
                dance.getId(),
                dance.getName(),
                dance.getRegion(),
                dance.getDescription(),
                dance.getVideoUrl()
        );
    }
}

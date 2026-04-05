package com.tfg.backend.controller;

import com.tfg.backend.domain.Dance;
import com.tfg.backend.service.DanceService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dances")
public class DanceController {

    private final DanceService danceService;

    public DanceController(DanceService danceService) {
        this.danceService = danceService;
    }

    @PostMapping
    public ResponseEntity<?> createDance(@RequestBody Dance dance) {
        danceService.saveDance(dance);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteDance(@PathVariable Long id) {
        danceService.deleteDanceById(id);
        return ResponseEntity.ok().build();
    }
}

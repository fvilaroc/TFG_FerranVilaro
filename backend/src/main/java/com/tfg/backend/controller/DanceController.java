package com.tfg.backend.controller;

import com.tfg.backend.domain.Dance;
import com.tfg.backend.service.DanceService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/dances")
public class DanceController {

    private final DanceService danceService;

    public DanceController(DanceService danceService) {
        this.danceService = danceService;
    }

    @GetMapping
    public List<Dance> getAllDances() {
        return danceService.findAll();
    }

    @PostMapping
    public Dance createDance(@RequestBody Dance dance) {
        return danceService.save(dance);
    }

    @DeleteMapping("/{id}")
    public void deleteDance(@PathVariable Long id) {
        danceService.deleteById(id);
    }

    @DeleteMapping("/all")
    public void deleteAll() {
        danceService.deleteAll();
    }
}

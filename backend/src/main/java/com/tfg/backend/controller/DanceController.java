package com.tfg.backend.controller;

import com.tfg.backend.domain.Dance;
import com.tfg.backend.service.DanceService;
import com.tfg.backend.service.dto.DanceDTO;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/dances")
public class DanceController {

    private final DanceService danceService;

    public DanceController(DanceService danceService) {
        this.danceService = danceService;
    }

    @PostMapping("/save")
    @PreAuthorize("hasAuthority('SCOPE_ADMIN')")
    public void createDance(@RequestBody Dance dance) {
        danceService.saveDance(dance);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('SCOPE_ADMIN')")
    public void deleteDance(@PathVariable Long id) {
        danceService.deleteDanceById(id);
    }

    @GetMapping("/all")
    @PreAuthorize("hasAnyAuthority('SCOPE_FREE', 'SCOPE_PREMIUM', 'SCOPE_ADMIN')")
    public List<DanceDTO> getAllDances() {
        return danceService.getAllDances();
    }

    @GetMapping("/{id}")
    public DanceDTO getDanceById(@PathVariable Long id) {
        return danceService.getDanceById(id);
    }
}

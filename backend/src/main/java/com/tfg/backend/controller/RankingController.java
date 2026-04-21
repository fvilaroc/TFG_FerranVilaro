package com.tfg.backend.controller;

import com.tfg.backend.service.RankingService;
import com.tfg.backend.service.dto.DanceRankingDTO;
import com.tfg.backend.service.dto.GlobalRankingDTO;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ranking")
public class RankingController {

    private final RankingService rankingService;

    public RankingController(RankingService rankingService) {
        this.rankingService = rankingService;
    }

    @GetMapping("/global")
    @PreAuthorize("hasAnyAuthority('SCOPE_FREE', 'SCOPE_PREMIUM', 'SCOPE_ADMIN')")
    public List<GlobalRankingDTO> getGlobalRanking() {
        return rankingService.getGlobalRanking();
    }

    @GetMapping("/dance/{danceId}")
    @PreAuthorize("hasAnyAuthority('SCOPE_PREMIUM', 'SCOPE_ADMIN')")
    public List<DanceRankingDTO> getDanceRanking(@PathVariable Long danceId) {
        return rankingService.getDanceRanking(danceId);
    }
}

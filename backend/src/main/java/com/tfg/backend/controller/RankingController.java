package com.tfg.backend.controller;

import com.tfg.backend.service.RankingService;
import com.tfg.backend.service.dto.DanceRankingDTO;
import com.tfg.backend.service.dto.GlobalRankingDTO;
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
    public List<GlobalRankingDTO> getGlobalRanking() {
        return rankingService.getGlobalRanking();
    }

    @GetMapping("/dance/{danceId}")
    public List<DanceRankingDTO> getDanceRanking(@PathVariable Long danceId) {
        return rankingService.getDanceRanking(danceId);
    }
}

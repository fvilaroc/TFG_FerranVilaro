package com.tfg.backend.service.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DanceDTO {

    private Long id;
    private String name;
    private String region;
    private String description;
    private String videoUrl;

    private String history;
    private String origin;
    private String clothing;
    private String musicCharacteristics;

    public DanceDTO() {}

    public DanceDTO(Long id, String name, String region, String description, String videoUrl, String history, String origin, String clothing, String musicCharacteristics) {
        this.id = id;
        this.name = name;
        this.region = region;
        this.description = description;
        this.videoUrl = videoUrl;
        this.history = history;
        this.origin = origin;
        this.clothing = clothing;
        this.musicCharacteristics = musicCharacteristics;
    }

}

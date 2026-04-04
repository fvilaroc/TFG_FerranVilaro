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

    public DanceDTO() {}
    
    public DanceDTO(Long id, String name, String region, String description, String videoUrl) {
        this.id = id;
        this.name = name;
        this.region = region;
        this.description = description;
        this.videoUrl = videoUrl;
    }

}

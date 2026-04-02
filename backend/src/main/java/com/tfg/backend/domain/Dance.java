package com.tfg.backend.domain;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "dances")
@Getter
@Setter
public class Dance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String region;

    @Column(length = 2000)
    private String description;

    private String videoUrl;

    public Dance() {}

    public Dance(String name, String region, String description, String videoUrl) {
        this.name = name;
        this.region = region;
        this.description = description;
        this.videoUrl = videoUrl;
    }
}

package com.tfg.backend.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

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

    @Lob
    private String history;
    @Lob
    private String origin;
    @Lob
    private String clothing;
    @Lob
    private String musicCharacteristics;

    @OneToMany(mappedBy = "dance")
    private List<UserDanceProgress> progresses;

    public Dance() {}

    public Dance(String name, String region, String description, String videoUrl, String history, String origin, String clothing, String musicCharacteristics) {
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

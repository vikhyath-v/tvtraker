package com.tvtracking.model;

import java.util.ArrayList;
import java.util.List;

public class Show {
    private String imdbID;
    private String title;
    private String year;
    private String poster;
    private String plot;
    private String imdbRating;
    private String genre;
    private String director;
    private String actors;
    private String runtime;
    private List<String> actorImages;

    public Show(String imdbID, String title, String year, String poster) {
        this.imdbID = imdbID;
        this.title = title;
        this.year = year;
        this.poster = poster;
        this.actorImages = new ArrayList<>();
    }

    public Show(String imdbID, String title, String year, String poster, 
                String plot, String genre, String director, String actors, 
                String runtime, String imdbRating) {
        this.imdbID = imdbID;
        this.title = title;
        this.year = year;
        this.poster = poster;
        this.plot = plot;
        this.genre = genre;
        this.director = director;
        this.actors = actors;
        this.runtime = runtime;
        this.imdbRating = imdbRating;
        this.actorImages = new ArrayList<>();
    }

    // Getters
    public String getImdbID() {
        return imdbID;
    }

    public void setImdbID(String imdbID) {
        this.imdbID = imdbID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public String getPlot() {
        return plot;
    }

    public void setPlot(String plot) {
        this.plot = plot;
    }

    public String getImdbRating() {
        return imdbRating;
    }

    public void setImdbRating(String imdbRating) {
        this.imdbRating = imdbRating;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getDirector() {
        return director;
    }

    public String getActors() {
        return actors;
    }

    public String getRuntime() {
        return runtime;
    }

    public List<String> getActorImages() {
        return actorImages;
    }

    public void setActorImages(List<String> actorImages) {
        this.actorImages = actorImages;
    }
} 
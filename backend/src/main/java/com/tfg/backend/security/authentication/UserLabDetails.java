package com.tfg.backend.security.authentication;

import com.tfg.backend.domain.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Collections;

public class UserLabDetails implements UserDetails {
    private final User userLab;

    public UserLabDetails(User userLab) {
        this.userLab = userLab;
    }

    @Override
    public String getPassword() {
        return userLab.getPassword();
    }

    @Override
    public String getUsername() {return userLab.getUsername();}


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {return Collections.emptyList();}

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public User getUser() {return userLab;}

}
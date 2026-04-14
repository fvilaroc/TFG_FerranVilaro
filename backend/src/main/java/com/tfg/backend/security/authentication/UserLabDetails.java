package com.tfg.backend.security.authentication;

import com.tfg.backend.domain.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.Collection;
import java.util.Collections;

public class UserLabDetails implements UserDetails {
    private final User userLab;
    private final Collection<? extends GrantedAuthority> authorities;

    public UserLabDetails(User userLab) {
        this.userLab = userLab;

        this.authorities = Collections.singletonList(new SimpleGrantedAuthority(userLab.getRoles().name()));
    }

    @Override
    public String getPassword() {
        return userLab.getPassword();
    }

    @Override
    public String getUsername() {return userLab.getUsername();}


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {return this.authorities;}

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

    @Override
    public String toString() {
        return "UserLab{" +
                ", username='" + getUsername() + '\'' +
                ", password='" + getPassword() + '\'' +
                ", roles=" + authorities.toString() +
                '}';
    }
}
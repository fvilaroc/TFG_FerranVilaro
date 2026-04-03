package com.tfg.backend.security.authentication;

import com.tfg.backend.domain.User;
import com.tfg.backend.persistance.UserLabRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserLabDetailsService implements UserDetailsService {
    private UserLabRepository userLabRepository;

    public UserLabDetailsService(UserLabRepository userLabRepository) {
        this.userLabRepository = userLabRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String name) throws UsernameNotFoundException {
        User user = userLabRepository.findByUsername(name)
                .orElseThrow(() -> new UsernameNotFoundException("User Not Found with this name: " + name));

        return new UserLabDetails(user);
    }

}

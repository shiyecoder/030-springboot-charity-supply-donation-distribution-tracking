package com.grad.cmt.config;

import com.grad.cmt.entity.SysUser;
import com.grad.cmt.mapper.SysUserMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 启动时把种子数据中的明文密码升级为 BCrypt 摘要（幂等）。
 * 种子 SQL 为了可读性存明文，首次启动后数据库内即为 BCrypt。
 */
@Component
public class DataInitializer implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);

    private final SysUserMapper userMapper;
    private final PasswordEncoder encoder;

    public DataInitializer(SysUserMapper userMapper, PasswordEncoder encoder) {
        this.userMapper = userMapper;
        this.encoder = encoder;
    }

    @Override
    public void run(ApplicationArguments args) {
        List<SysUser> users = userMapper.selectList(null);
        int n = 0;
        for (SysUser u : users) {
            String pwd = u.getPassword();
            if (pwd != null && !pwd.startsWith("$2")) {
                u.setPassword(encoder.encode(pwd));
                userMapper.updateById(u);
                n++;
            }
        }
        if (n > 0) {
            log.info("已将 {} 个账号的明文密码升级为 BCrypt", n);
        }
    }
}

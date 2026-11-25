package com.grad.cmt.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * 静态资源映射：/uploads/** → 项目根目录 uploads/。
 *
 * <p>项目约定：种子图片与上传文件都放在**项目根目录**下的 uploads/，数据库只存
 * 相对路径（如 /uploads/seed/avatar/01.jpg）。后端有两种启动方式：
 * <ul>
 *   <li>在 backend/ 下执行 java -jar target/xxx.jar —— ./uploads 指向 backend/uploads（不存在），
 *       此时自动回退到上一级目录的 uploads/</li>
 *   <li>在项目根执行 java -jar backend/target/xxx.jar —— ./uploads 直接命中</li>
 * </ul>
 * 因此这里按候选目录依次探测，取第一个真实存在的，避免换机器、换启动目录就 404。
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    private static final Logger log = LoggerFactory.getLogger(WebConfig.class);

    @Value("${app.upload-dir:./uploads}")
    private String uploadDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path resolved = resolveUploadDir();
        log.info("静态资源映射 /uploads/** -> {}", resolved);
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + resolved + "/")
                .setCachePeriod(3600);
    }

    /** 依次探测候选上传目录，取第一个真实存在的绝对路径。 */
    private Path resolveUploadDir() {
        Path cwd = Paths.get("").toAbsolutePath().normalize();
        Path[] candidates = new Path[]{
                cwd.resolve(uploadDir).normalize(),
                cwd.resolve("uploads").normalize(),
                cwd.resolve("../uploads").normalize().toAbsolutePath().normalize(),
                cwd.resolve("../../uploads").normalize().toAbsolutePath().normalize()
        };
        for (Path p : candidates) {
            if (Files.isDirectory(p)) {
                return p;
            }
        }
        Path fallback = cwd.resolve("uploads").normalize();
        try {
            Files.createDirectories(fallback);
        } catch (Exception ignored) {
            // 目录创建失败时仍返回路径，后续访问由 Spring 返回 404，不影响启动
        }
        return fallback;
    }
}

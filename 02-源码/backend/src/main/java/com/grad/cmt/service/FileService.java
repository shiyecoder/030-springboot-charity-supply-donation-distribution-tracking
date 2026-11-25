package com.grad.cmt.service;

import com.grad.cmt.common.BizException;
import com.grad.cmt.common.UserContext;
import com.grad.cmt.entity.MaterialAttachment;
import com.grad.cmt.entity.SysFile;
import com.grad.cmt.mapper.MaterialAttachmentMapper;
import com.grad.cmt.mapper.SysFileMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * 文件上传：统一落盘到项目根目录 uploads/，数据库只保存相对路径。
 * 业务附件与图片分别写 sys_file 与 charity_material_attachment，便于溯源。
 */
@Service
public class FileService {

    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("yyyyMM");
    private static final long MAX_SIZE = 20L * 1024 * 1024;

    private final SysFileMapper fileMapper;
    private final MaterialAttachmentMapper attachMapper;

    @Value("${app.upload-dir:./uploads}")
    private String uploadDir;

    public FileService(SysFileMapper fileMapper, MaterialAttachmentMapper attachMapper) {
        this.fileMapper = fileMapper;
        this.attachMapper = attachMapper;
    }

    public SysFile upload(MultipartFile file, String bizType, Long bizId) {
        if (file == null || file.isEmpty()) {
            throw new BizException("请选择要上传的文件");
        }
        if (file.getSize() > MAX_SIZE) {
            throw new BizException("单个文件不能超过 20MB");
        }
        String original = file.getOriginalFilename() == null ? "file" : file.getOriginalFilename();
        String ext = original.contains(".") ? original.substring(original.lastIndexOf('.')) : "";
        String month = LocalDateTime.now().format(DF);
        String name = UUID.randomUUID().toString().replace("-", "") + ext;
        try {
            Path dir = Paths.get(uploadDir, month).toAbsolutePath().normalize();
            Files.createDirectories(dir);
            file.transferTo(dir.resolve(name).toFile());
        } catch (IOException e) {
            throw new BizException("文件保存失败：" + e.getMessage());
        }
        String relative = "/uploads/" + month + "/" + name;

        SysFile f = new SysFile();
        f.setFileName(original);
        f.setFilePath(relative);
        f.setFileSize(file.getSize());
        f.setContentType(file.getContentType());
        f.setBizType(bizType);
        f.setUploaderId(UserContext.userId());
        f.setUploadTime(LocalDateTime.now());
        fileMapper.insert(f);

        if (bizId != null) {
            MaterialAttachment a = new MaterialAttachment();
            a.setBizType(bizType);
            a.setBizId(bizId);
            a.setFileName(original);
            a.setFilePath(relative);
            a.setFileSize(file.getSize());
            a.setContentType(file.getContentType());
            a.setUploaderId(UserContext.userId());
            a.setUploadTime(LocalDateTime.now());
            attachMapper.insert(a);
        }
        return f;
    }
}

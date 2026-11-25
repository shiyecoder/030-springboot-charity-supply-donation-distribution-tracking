package com.grad.cmt.controller;

import com.grad.cmt.common.R;
import com.grad.cmt.entity.SysFile;
import com.grad.cmt.service.FileService;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

/** 文件上传接口：返回相对路径，前端直接回填到表单，禁止手填 URL。 */
@RestController
@RequestMapping("/api/file")
public class FileController {

    private final FileService fileService;

    public FileController(FileService fileService) {
        this.fileService = fileService;
    }

    @PostMapping("/upload")
    public R<Map<String, Object>> upload(@RequestParam("file") MultipartFile file,
                                         @RequestParam(required = false) String bizType,
                                         @RequestParam(required = false) Long bizId) {
        SysFile f = fileService.upload(file, bizType == null ? "common" : bizType, bizId);
        Map<String, Object> data = new HashMap<>();
        data.put("id", f.getId());
        data.put("name", f.getFileName());
        data.put("path", f.getFilePath());
        data.put("size", f.getFileSize());
        return R.ok(data);
    }
}

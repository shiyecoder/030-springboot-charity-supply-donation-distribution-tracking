package com.grad.cmt.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.*;
import java.math.BigDecimal;

/**
 * 文件（表 sys_file）
 */
@Data
@TableName("sys_file")
public class SysFile {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 原始文件名 */
    private String fileName;

    /** 相对路径 */
    private String filePath;

    /** 文件大小 */
    private Long fileSize;

    /** 文件类型 */
    private String contentType;

    /** 业务类型 */
    private String bizType;

    /** 上传人 */
    private Long uploaderId;

    /** 上传时间 */
    private java.time.LocalDateTime uploadTime;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
    private Integer version;
}

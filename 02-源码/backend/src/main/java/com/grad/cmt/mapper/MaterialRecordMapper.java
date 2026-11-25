package com.grad.cmt.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.grad.cmt.entity.MaterialRecord;
import org.apache.ibatis.annotations.Mapper;

/** 过程记录与状态流转 Mapper */
@Mapper
public interface MaterialRecordMapper extends BaseMapper<MaterialRecord> {
}

package com.grad.cmt.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.grad.cmt.entity.InventoryBatch;
import org.apache.ibatis.annotations.Mapper;

/** 物资入库批次 Mapper */
@Mapper
public interface InventoryBatchMapper extends BaseMapper<InventoryBatch> {
}

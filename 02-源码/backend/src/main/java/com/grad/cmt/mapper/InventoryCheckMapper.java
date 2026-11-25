package com.grad.cmt.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.grad.cmt.entity.InventoryCheck;
import org.apache.ibatis.annotations.Mapper;

/** 库存盘点 Mapper */
@Mapper
public interface InventoryCheckMapper extends BaseMapper<InventoryCheck> {
}

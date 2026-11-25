package com.grad.cmt.service;

import com.grad.cmt.common.UserContext;
import com.grad.cmt.entity.MaterialRecord;
import com.grad.cmt.entity.SysMessage;
import com.grad.cmt.mapper.MaterialRecordMapper;
import com.grad.cmt.mapper.SysMessageMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * 状态流转留痕与站内消息。
 * 任何改变业务状态的操作都必须调用 record 落一条不可修改的过程记录，
 * 供详情页时间轴与操作日志核对；关键节点同时推送站内消息。
 */
@Service
public class FlowService {

    private final MaterialRecordMapper recordMapper;
    private final SysMessageMapper messageMapper;

    public FlowService(MaterialRecordMapper recordMapper, SysMessageMapper messageMapper) {
        this.recordMapper = recordMapper;
        this.messageMapper = messageMapper;
    }

    /** 写一条状态流转记录：操作人、时间、前后状态与原因 */
    public void record(String bizType, Long bizId, String bizNo, String from, String to,
                       String action, String reason) {
        MaterialRecord r = new MaterialRecord();
        r.setBizType(bizType);
        r.setBizId(bizId);
        r.setBizNo(bizNo);
        r.setFromStatus(from);
        r.setToStatus(to);
        r.setAction(action);
        r.setReason(reason);
        r.setOperatorId(UserContext.userId());
        r.setOperatorName(UserContext.name());
        r.setOperateTime(LocalDateTime.now());
        recordMapper.insert(r);
    }

    public void notify(Long receiverId, String msgType, String title, String content,
                       String bizType, String bizNo, Long bizId, String url) {
        if (receiverId == null) {
            return;
        }
        SysMessage m = new SysMessage();
        m.setTitle(title);
        m.setContent(content);
        m.setMsgType(msgType);
        m.setBizType(bizType);
        m.setBizNo(bizNo);
        m.setBizId(bizId);
        m.setBizUrl(url);
        m.setReceiverId(receiverId);
        m.setReadFlag(0);
        messageMapper.insert(m);
    }
}

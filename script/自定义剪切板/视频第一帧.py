import cv2
#为什么我不用lua写？因为trime没库我TM不会啊！(更可能是我菜)
# 打开视频文件
cap = cv2.VideoCapture('bg.mp4')

# 读取视频第一帧
ret, frame = cap.read()

if ret:
    # 保存第一帧为图片
    cv2.imwrite('bg_frame.jpg', frame)

# 释放资源
cap.release()

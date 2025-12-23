# 📋 Booking API - Hướng Dẫn Sử Dụng

## 🔗 Base URL

```
http://localhost:8100/api/v1/bookings
```

**Lưu ý:** 
- Android Emulator: `http://10.0.2.2:8100`
- iOS Simulator: `http://localhost:8100`
- Physical Device: `http://<YOUR_COMPUTER_IP>:8100`

---

## 🔐 Authentication

Tất cả endpoints yêu cầu JWT token trong header:

```
Authorization: Bearer <JWT_TOKEN>
```

**Role Required:** `CUSTOMER`

---

## 📊 Booking Status

| Status | Mô tả |
|--------|-------|
| `PENDING` | Đơn đặt đang chờ xử lý |
| `COMPLETED` | Đơn đặt đã hoàn thành |
| `CANCELLED` | Đơn đặt đã bị hủy |

**Lưu ý:** Chỉ booking có status `PENDING` mới có thể được cập nhật hoặc hủy.

---

## 🚀 API Endpoints

### 1. Tạo Booking Mới

**Endpoint:** `POST /api/v1/bookings`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

**Request Body:**
```json
{
  "title": "Sửa chữa máy lạnh",
  "address": "123 Đường ABC, Phường XYZ, Quận 1, TP.HCM",
  "date": "2024-12-25T14:00:00",
  "phone": "0901234567",
  "name": "Nguyễn Văn A",
  "notes": "Máy lạnh không lạnh, cần kiểm tra gas",
  "wardCode": "27601",
  "needsSurvey": true
}
```

**Request Fields:**

| Field | Type | Required | Max Length | Mô tả |
|-------|------|----------|-----------|-------|
| `title` | String | ✅ Yes | 200 | Tên dịch vụ |
| `address` | String | ✅ Yes | - | Địa chỉ đầy đủ |
| `date` | DateTime (ISO8601) | ✅ Yes | - | Thời gian hẹn (format: YYYY-MM-DDTHH:mm:ss) |
| `phone` | String | ✅ Yes | 20 | Số điện thoại |
| `name` | String | ✅ Yes | 100 | Tên khách hàng |
| `notes` | String | ❌ No | 1000 | Ghi chú (optional) |
| `wardCode` | String | ❌ No | 20 | Mã phường/xã (optional) |
| `needsSurvey` | Boolean | ❌ No | - | Cần khảo sát (optional, default: false) |

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Booking created successfully",
  "data": {
    "id": 1,
    "title": "Sửa chữa máy lạnh",
    "address": "123 Đường ABC, Phường XYZ, Quận 1, TP.HCM",
    "date": "2024-12-25T14:00:00",
    "notes": "Máy lạnh không lạnh, cần kiểm tra gas",
    "phone": "0901234567",
    "name": "Nguyễn Văn A",
    "wardCode": "27601",
    "needsSurvey": true,
    "status": "PENDING",
    "createdAt": "2024-12-20T10:30:00",
    "updatedAt": "2024-12-20T10:30:00"
  },
  "timestamp": "2024-12-20T10:30:00"
}
```

**cURL Example:**
```bash
curl -X POST http://localhost:8100/api/v1/bookings \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Sửa chữa máy lạnh",
    "address": "123 Đường ABC, Phường XYZ, Quận 1, TP.HCM",
    "date": "2024-12-25T14:00:00",
    "notes": "Máy lạnh không lạnh",
    "phone": "0901234567",
    "name": "Nguyễn Văn A",
    "wardCode": "27601",
    "needsSurvey": true
  }'
```

---

### 2. Lấy Danh Sách Bookings

**Endpoint:** `GET /api/v1/bookings`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Query Parameters:**

| Parameter | Type | Required | Default | Mô tả |
|-----------|------|----------|---------|-------|
| `status` | String | ❌ No | - | Lọc theo status: `PENDING`, `COMPLETED`, `CANCELLED` |
| `page` | Integer | ❌ No | 0 | Số trang (0-based) |
| `limit` | Integer | ❌ No | 10 | Số lượng items mỗi trang (max: 100) |

**Request Examples:**

```
GET /api/v1/bookings
GET /api/v1/bookings?status=PENDING
GET /api/v1/bookings?page=0&limit=20
GET /api/v1/bookings?status=COMPLETED&page=1&limit=15
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Bookings retrieved successfully",
  "data": {
    "bookings": [
      {
        "id": 1,
        "title": "Sửa chữa máy lạnh",
        "address": "123 Đường ABC, Phường XYZ, Quận 1, TP.HCM",
        "date": "2024-12-25T14:00:00",
        "notes": "Máy lạnh không lạnh, cần kiểm tra gas",
        "phone": "0901234567",
        "name": "Nguyễn Văn A",
        "wardCode": "27601",
        "needsSurvey": true,
        "status": "PENDING",
        "createdAt": "2024-12-20T10:30:00",
        "updatedAt": "2024-12-20T10:30:00"
      },
      {
        "id": 2,
        "title": "Lắp đặt quạt trần",
        "address": "456 Đường DEF, Phường UVW, Quận 2, TP.HCM",
        "date": "2024-12-26T09:00:00",
        "notes": null,
        "phone": "0907654321",
        "name": "Trần Thị B",
        "wardCode": "27602",
        "needsSurvey": false,
        "status": "COMPLETED",
        "createdAt": "2024-12-19T08:15:00",
        "updatedAt": "2024-12-26T10:00:00"
      }
    ],
    "total": 2,
    "page": 0,
    "limit": 10
  },
  "timestamp": "2024-12-20T10:35:00"
}
```

**cURL Example:**
```bash
curl -X GET "http://localhost:8100/api/v1/bookings?status=PENDING&page=0&limit=10" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

### 3. Lấy Chi Tiết Booking

**Endpoint:** `GET /api/v1/bookings/{id}`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Path Parameters:**

| Parameter | Type | Required | Mô tả |
|-----------|------|----------|-------|
| `id` | Long | ✅ Yes | ID của booking |

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Booking details retrieved successfully",
  "data": {
    "id": 1,
    "title": "Sửa chữa máy lạnh",
    "address": "123 Đường ABC, Phường XYZ, Quận 1, TP.HCM",
    "date": "2024-12-25T14:00:00",
    "notes": "Máy lạnh không lạnh, cần kiểm tra gas",
    "phone": "0901234567",
    "name": "Nguyễn Văn A",
    "wardCode": "27601",
    "needsSurvey": true,
    "status": "PENDING",
    "createdAt": "2024-12-20T10:30:00",
    "updatedAt": "2024-12-20T10:30:00"
  },
  "timestamp": "2024-12-20T10:40:00"
}
```

**Error Response (404 Not Found):**
```json
{
  "success": false,
  "message": "Booking ID 1 not found for user ID 123",
  "data": null,
  "timestamp": "2024-12-20T10:40:00"
}
```

**cURL Example:**
```bash
curl -X GET http://localhost:8100/api/v1/bookings/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

### 4. Cập Nhật Booking

**Endpoint:** `PUT /api/v1/bookings/{id}`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

**Path Parameters:**

| Parameter | Type | Required | Mô tả |
|-----------|------|----------|-------|
| `id` | Long | ✅ Yes | ID của booking |

**Request Body:** (Tất cả các fields đều optional - chỉ gửi fields cần cập nhật)

```json
{
  "title": "Sửa chữa máy lạnh - Cập nhật",
  "address": "123 Đường ABC, Phường XYZ, Quận 1, TP.HCM - Tầng 5",
  "date": "2024-12-26T15:00:00",
  "notes": "Đã kiểm tra, cần thay gas",
  "phone": "0901234567",
  "name": "Nguyễn Văn A",
  "wardCode": "27601",
  "needsSurvey": false
}
```

**Request Fields:** (Tất cả optional)

| Field | Type | Max Length | Mô tả |
|-------|------|-----------|-------|
| `title` | String | 200 | Tên dịch vụ |
| `address` | String | - | Địa chỉ đầy đủ |
| `date` | DateTime (ISO8601) | - | Thời gian hẹn |
| `notes` | String | 1000 | Ghi chú |
| `phone` | String | 20 | Số điện thoại |
| `name` | String | 100 | Tên khách hàng |
| `wardCode` | String | 20 | Mã phường/xã |
| `needsSurvey` | Boolean | - | Cần khảo sát |

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Booking updated successfully",
  "data": {
    "id": 1,
    "title": "Sửa chữa máy lạnh - Cập nhật",
    "address": "123 Đường ABC, Phường XYZ, Quận 1, TP.HCM - Tầng 5",
    "date": "2024-12-26T15:00:00",
    "notes": "Đã kiểm tra, cần thay gas",
    "phone": "0901234567",
    "name": "Nguyễn Văn A",
    "wardCode": "27601",
    "needsSurvey": false,
    "status": "PENDING",
    "createdAt": "2024-12-20T10:30:00",
    "updatedAt": "2024-12-20T11:00:00"
  },
  "timestamp": "2024-12-20T11:00:00"
}
```

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Cannot update booking with status: COMPLETED",
  "data": null,
  "timestamp": "2024-12-20T11:00:00"
}
```

**cURL Example:**
```bash
curl -X PUT http://localhost:8100/api/v1/bookings/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "date": "2024-12-26T15:00:00",
    "notes": "Đã kiểm tra, cần thay gas"
  }'
```

---

### 5. Hủy Booking

**Endpoint:** `POST /api/v1/bookings/{id}/cancel`

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Path Parameters:**

| Parameter | Type | Required | Mô tả |
|-----------|------|----------|-------|
| `id` | Long | ✅ Yes | ID của booking |

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Booking cancelled successfully",
  "data": {
    "id": 1,
    "title": "Sửa chữa máy lạnh",
    "address": "123 Đường ABC, Phường XYZ, Quận 1, TP.HCM",
    "date": "2024-12-25T14:00:00",
    "notes": "Máy lạnh không lạnh, cần kiểm tra gas",
    "phone": "0901234567",
    "name": "Nguyễn Văn A",
    "wardCode": "27601",
    "needsSurvey": true,
    "status": "CANCELLED",
    "createdAt": "2024-12-20T10:30:00",
    "updatedAt": "2024-12-20T11:05:00"
  },
  "timestamp": "2024-12-20T11:05:00"
}
```

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Cannot cancel booking with status: COMPLETED",
  "data": null,
  "timestamp": "2024-12-20T11:05:00"
}
```

**cURL Example:**
```bash
curl -X POST http://localhost:8100/api/v1/bookings/1/cancel \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## ⚠️ Error Handling

### HTTP Status Codes

| Code | Mô tả | Khi nào xảy ra |
|------|-------|----------------|
| `200` | OK | Request thành công |
| `201` | Created | Booking được tạo thành công |
| `400` | Bad Request | Dữ liệu request không hợp lệ hoặc booking không ở trạng thái phù hợp |
| `401` | Unauthorized | Thiếu hoặc JWT token không hợp lệ |
| `403` | Forbidden | Không có quyền truy cập (không phải CUSTOMER role) |
| `404` | Not Found | Booking không tồn tại hoặc không thuộc về user hiện tại |
| `500` | Internal Server Error | Lỗi server |

### Error Response Format

```json
{
  "success": false,
  "message": "Error description",
  "data": null,
  "timestamp": "2024-12-20T10:30:00"
}
```

### Common Error Scenarios

**1. Cập nhật/Hủy booking không phải PENDING:**
```json
{
  "success": false,
  "message": "Cannot update booking with status: COMPLETED"
}
```

**2. Booking không tồn tại hoặc không thuộc về user:**
```json
{
  "success": false,
  "message": "Booking ID 999 not found for user ID 123"
}
```

**3. Validation errors:**
```json
{
  "success": false,
  "message": "Validation failed",
  "data": {
    "title": "Title is required",
    "date": "Date is required"
  }
}
```

---

## 📝 Notes

1. **Date Format:** Tất cả datetime fields sử dụng ISO8601 format: `YYYY-MM-DDTHH:mm:ss`
   - Example: `2024-12-25T14:00:00`

2. **Pagination:** 
   - Page bắt đầu từ 0
   - Limit mặc định là 10, tối đa 100
   - Kết quả được sắp xếp theo `createdAt` descending (mới nhất trước)

3. **Authorization:**
   - Mỗi user chỉ có thể xem/sửa booking của chính mình
   - Hệ thống tự động lấy user từ JWT token

4. **Status Rules:**
   - Chỉ booking có status `PENDING` mới có thể được update hoặc cancel
   - Booking `COMPLETED` hoặc `CANCELLED` không thể thay đổi

5. **Validation:**
   - Tất cả required fields phải được cung cấp khi tạo booking
   - String fields có giới hạn độ dài tối đa
   - Date phải là datetime hợp lệ

---

## 🔍 Testing với Swagger UI

API này đã được tích hợp vào Swagger UI. Để test:

1. Khởi động ứng dụng Spring Boot
2. Truy cập: `http://localhost:8100/swagger-ui.html`
3. Tìm section "Booking Controller"
4. Click "Authorize" và nhập JWT token
5. Test các endpoints trực tiếp từ Swagger UI


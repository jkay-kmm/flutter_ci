# flutter_ci

A new Flutter project.

## Làm theo các bước ở file main.yaml




- [Mở project bằng bất kì IDE nào mà bạn thích, tạo file main.yaml trong .github/workflows/main.yaml (Tạo các folder .github, workflows nếu chưa có). File này chính là nơi chúng ta config workflow.](https://docs.flutter.dev/get-started/codelab)
- [Tạo GitHub Personal Access Token (Mã thông báo cá nhân)
  Mã này đóng vai trò như một chiếc "chìa khóa" để GitHub Actions có quyền truy cập và thực hiện các thay đổi (như tạo bản release) trên repo của bạn.

Đăng nhập vào GitHub, bấm vào ảnh đại diện của bạn ở góc trên cùng bên phải màn hình, chọn Settings (Cài đặt).

Cuộn thanh điều hướng bên trái xuống dưới cùng và chọn Developer settings (Cài đặt dành cho nhà phát triển).

Ở menu bên trái, chọn Personal access tokens, sau đó click vào Tokens (classic).

Bấm vào nút Generate new token ở góc phải và chọn Generate new token (classic). (Hệ thống có thể yêu cầu bạn nhập lại mật khẩu GitHub).

Điền các thông tin cần thiết:

Note: Đặt một cái tên để dễ nhớ, ví dụ: Flutter CI/CD Token.

Expiration: Chọn thời hạn sống cho token (ví dụ: 30 days, 90 days, hoặc No expiration).

Select scopes: Đây là phần quan trọng nhất. Hãy tích vào ô repo (để cấp toàn quyền kiểm soát các kho lưu trữ cá nhân).

Cuộn xuống cuối trang và bấm nút xanh Generate token.

Màn hình sẽ hiện ra một đoạn mã dài (thường bắt đầu bằng ghp_...). Hãy copy đoạn mã này ngay lập tức vì GitHub sẽ chỉ hiển thị nó một lần duy nhất.

Phần 2: Thêm Token vào kho lưu trữ (Repository Secrets)
Bây giờ bạn cần mang "chìa khóa" vừa tạo cất vào két sắt của dự án để file main.yaml có thể lấy ra sử dụng ở dòng ${{ secrets.TOKEN }}.

Quay trở lại trang chính của kho lưu trữ (repository) chứa code Flutter của bạn.

Bấm vào tab Settings (Cài đặt) của repo đó.

Ở thanh menu bên trái, tìm mục Security, xổ tab Secrets and variables ra và chọn Actions.

Bấm vào nút màu xanh New repository secret (Thêm secret mới cho kho lưu trữ).

Điền thông tin như sau:

Name: Nhập chính xác là TOKEN (viết hoa toàn bộ, vì trong file config ở Bước 3 tác giả đang gọi tên nó là TOKEN).

Secret: Dán (Paste) đoạn mã ghp_... mà bạn vừa copy ở Phần 1 vào đây.

Bấm Add secret.]()
Bước 5 đẩy code lên Khi chúng ta đã tạo xong workflow file và thêm token vào project, chúng ta có thể push code lên Github với release tag và chạy workflow đã tạo.

Ở dưới local, hãy commit tất cả các file bao gồm cả main.yaml phía trên và tạo một tag mới sử dụng lệnh git tag và đẩy code lên cùng với tag.

Ví dụ:

git tag v1.0

git push origin v1.0

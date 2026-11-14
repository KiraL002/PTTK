"use strict";
document.addEventListener("DOMContentLoaded", () => {
  const print = document.getElementById("print-invoice");
  if (print) print.addEventListener("click", () => window.print());
  const startDate = document.getElementById("startDate"), endDate = document.getElementById("endDate");
  if (startDate && endDate) {
    const validate = () => endDate.setCustomValidity(startDate.value && endDate.value && endDate.value < startDate.value ? "Ngày kết thúc phải từ ngày bắt đầu trở đi." : "");
    startDate.addEventListener("input", validate); endDate.addEventListener("input", validate);
  }
});

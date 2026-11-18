"use strict";

function isoDate(value) {
    const parts = /^(\d{2})\/(\d{2})\/(\d{4})$/.exec(value.trim());
    if (!parts) return "";

    const [, day, month, year] = parts;
    if (Number(year) < 1900 || Number(year) > 9998) return "";

    const date = new Date(Date.UTC(Number(year), Number(month) - 1, Number(day)));
    if (date.getUTCMonth() !== Number(month) - 1 || date.getUTCDate() !== Number(day)) return "";
    return `${year}-${month}-${day}`;
}

document.addEventListener("DOMContentLoaded", () => {
    const print = document.getElementById("print-invoice");
    if (print) print.addEventListener("click", () => window.print());

    const startDate = document.getElementById("startDate");
    const endDate = document.getElementById("endDate");
    if (!startDate || !endDate) return;

    const validate = () => {
        const start = isoDate(startDate.value);
        const end = isoDate(endDate.value);
        startDate.setCustomValidity("");
        endDate.setCustomValidity(
            start && end && end < start ? "Ngày kết thúc phải từ ngày bắt đầu trở đi." : "",
        );
    };

    for (const field of [startDate, endDate]) {
        field.addEventListener("input", validate);
        field.addEventListener("invalid", () => {
            if (field.validity.valueMissing) {
                field.setCustomValidity("Vui lòng nhập đủ ngày bắt đầu và ngày kết thúc.");
            }
        });

        const controls = field.nextElementSibling;
        const picker = controls.querySelector("input");
        if (picker.type !== "date" || typeof picker.showPicker !== "function") continue;

        controls.hidden = false;
        controls.querySelector("button").addEventListener("click", () => {
            picker.value = isoDate(field.value);
            picker.showPicker();
        });
        picker.addEventListener("change", () => {
            if (!picker.value) return;
            const [year, month, day] = picker.value.split("-");
            field.value = `${day}/${month}/${year}`;
            validate();
        });
    }
});

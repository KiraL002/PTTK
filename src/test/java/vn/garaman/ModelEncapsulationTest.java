package vn.garaman;

import java.math.BigDecimal;
import org.junit.Test;
import static org.junit.Assert.*;
import vn.garaman.model.*;

public class ModelEncapsulationTest {
    @Test public void replacingAnExternalArrayEntryDoesNotChangeInvoiceContentsOrTotals() {
        InvoiceService3 service = new InvoiceService3();
        service.setQuantity(2);
        service.setPrice(new BigDecimal("100000"));
        InvoicePart3 part = new InvoicePart3();
        part.setQuantity(new BigDecimal("1.5"));
        part.setPrice(new BigDecimal("50000"));

        InvoiceService3[] services = {service};
        InvoicePart3[] parts = {part};
        Invoice3 invoice = new Invoice3();
        invoice.setInvoiceServices(services);
        invoice.setInvoiceParts(parts);

        services[0] = null;
        parts[0] = null;
        invoice.getInvoiceServices()[0] = null;
        invoice.getInvoiceParts()[0] = null;

        assertSame(service, invoice.getInvoiceServices()[0]);
        assertSame(part, invoice.getInvoiceParts()[0]);
        assertEquals(0, new BigDecimal("200000").compareTo(invoice.getServiceTotal()));
        assertEquals(0, new BigDecimal("75000").compareTo(invoice.getPartTotal()));
    }

    @Test public void relationArraysAreProtectedOnBothInputAndOutput() {
        Customer3 customer = new Customer3();
        Car3 car = new Car3();
        SalesStaff3 staff = new SalesStaff3();
        Service3 service = new Service3();
        Invoice3 invoice = new Invoice3();
        Appointment3 appointment = new Appointment3();
        ServicePart3 servicePart = new ServicePart3();
        Car3[] cars = {car};
        Appointment3[] appointments = {appointment};
        Invoice3[] invoices = {invoice};
        ServicePart3[] serviceParts = {servicePart};

        customer.setCars(cars);
        customer.setAppointments(appointments);
        customer.setInvoices(invoices);
        car.setInvoices(invoices);
        staff.setInvoices(invoices);
        service.setServiceParts(serviceParts);
        cars[0] = null;
        appointments[0] = null;
        invoices[0] = null;
        serviceParts[0] = null;
        customer.getCars()[0] = null;
        customer.getAppointments()[0] = null;
        customer.getInvoices()[0] = null;
        car.getInvoices()[0] = null;
        staff.getInvoices()[0] = null;
        service.getServiceParts()[0] = null;

        assertSame(car, customer.getCars()[0]);
        assertSame(appointment, customer.getAppointments()[0]);
        assertSame(invoice, customer.getInvoices()[0]);
        assertSame(invoice, car.getInvoices()[0]);
        assertSame(invoice, staff.getInvoices()[0]);
        assertSame(servicePart, service.getServiceParts()[0]);
    }

    @Test public void absentRelationsRemainEmptyArrays() {
        Invoice3 invoice = new Invoice3();
        invoice.setInvoiceServices(null);
        invoice.setInvoiceParts(null);
        Customer3 customer = new Customer3();
        customer.setCars(null);
        customer.setAppointments(null);
        customer.setInvoices(null);
        Car3 car = new Car3();
        car.setInvoices(null);
        SalesStaff3 staff = new SalesStaff3();
        staff.setInvoices(null);
        Service3 service = new Service3();
        service.setServiceParts(null);

        assertEquals(0, invoice.getInvoiceServices().length);
        assertEquals(0, invoice.getInvoiceParts().length);
        assertEquals(0, customer.getCars().length);
        assertEquals(0, customer.getAppointments().length);
        assertEquals(0, customer.getInvoices().length);
        assertEquals(0, car.getInvoices().length);
        assertEquals(0, staff.getInvoices().length);
        assertEquals(0, service.getServiceParts().length);
    }
}

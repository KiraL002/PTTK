package vn.garaman.dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import vn.garaman.model.CustomerStatistics3;
import vn.garaman.util.Period;

public class CustomerStatisticsDAO3 extends DAO3 {
    public CustomerStatisticsDAO3(Connection con) {
        super(con);
    }

    public CustomerStatistics3[] getStatistics(LocalDate startDate, LocalDate endDate)
            throws SQLException {
        Period period = new Period(startDate, endDate);
        String sql =
                "SELECT c.id,c.fullName,c.address,c.phone,c.customerType,COUNT(i.id) AS visitCount,SUM("
                        + INVOICE_TOTAL
                        + ") AS totalRevenue "
                        + "FROM tblCustomer3 c JOIN tblInvoice3 i ON i.tblCustomer3id=c.id "
                        + "WHERE i.status='PAID' AND i.paymentDate>=? AND i.paymentDate<? "
                        + "GROUP BY c.id,c.fullName,c.address,c.phone,c.customerType ORDER BY totalRevenue DESC,c.id";
        List<CustomerStatistics3> result = new ArrayList<>();
        try (PreparedStatement statement = prepare(sql)) {
            statement.setTimestamp(1, period.getFromTimestamp());
            statement.setTimestamp(2, period.getUntilTimestamp());
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    CustomerStatistics3 customer =
                            ModelMapper.customer(rows, new CustomerStatistics3());
                    customer.setVisitCount(rows.getInt("visitCount"));
                    customer.setTotalRevenue(rows.getBigDecimal("totalRevenue"));
                    result.add(customer);
                }
            }
        }
        return result.toArray(new CustomerStatistics3[0]);
    }
}

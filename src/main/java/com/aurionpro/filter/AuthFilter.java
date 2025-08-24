package com.aurionpro.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {
        "/AdminController", 
        "/CustomerController", 
        "/TransactionController", 
        "/WEB-INF/views/*" 
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);

     
        boolean loggedIn = (session != null && session.getAttribute("username") != null);

        boolean loginRequest = uri.endsWith("login.jsp") 
                                || uri.contains("/auth") 
                                || uri.contains("css") 
                                || uri.contains("js") 
                                || uri.contains("images");

        if (loggedIn || loginRequest) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/auth"); 
        }
    }
}
